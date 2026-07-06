# ==== JSON Schema -> ellmer type converter ======================================
# Targeted converter for THIS project's schema.json. Reads the canonical JSON
# Schema (your team-reviewed artifact) and builds the ellmer type_object() used
# as the generation constraint at the API call site.
#
# WHY a converter rather than hand-coded ellmer types: schema.json reuses five
# $defs (scored_element, component_flag, tool_element, climate_tool_element,
# evidence_quote) across ~25 element slots via $ref. Hand-coding means expanding
# every $ref inline and re-expanding on every codebook revision, with drift
# guaranteed. This keeps schema.json canonical and derives the R from it.
#
# WHY targeted, not general: this handles exactly the constructs the schema uses
# (object/array/string/integer/boolean, nullable scalars via ["T","null"], $ref,
# $defs). It FAILS LOUDLY on anything it doesn't recognize — which is what you
# want for a load-bearing artifact. A new construct errors instead of silently
# mis-converting.
#
# WHAT GETS DROPPED (deliberately): minimum/maximum/maxLength/maxItems and
# additionalProperties. Provider structured output does not reliably enforce
# these. They remain in schema.json and are enforced in the postprocessing
# validation pass (codebook §7) via a real JSON Schema validator (jsonvalidate),
# NOT here. This file builds the GENERATION constraint; schema.json remains the
# VALIDATION contract. Keep the two jobs separate.

library(jsonlite)
library(ellmer)

# ==== Nullable detection ========================================================
# JSON Schema expresses nullable as a type array, e.g. {"type": ["integer","null"]}.
# ellmer has no true "nullable" — the closest is required = FALSE on the field.
# These are NOT identical: required=FALSE means "may be omitted", while the schema
# means "present but may be null". Your prompt leans on null != 0 != absent.
# We map nullable -> required = FALSE and rely on the prompt to enforce the
# null/0 distinction, then enforce it for real in validation. See note in README.

.is_nullable <- function(node) {
      t <- node$type
      # `type` may arrive as a character vector OR an unboxed list depending on how
      # jsonlite parsed it. unlist() normalizes both to a character vector.
      t <- unlist(t)
      is.character(t) && length(t) > 1 && "null" %in% t
}

# Return the single non-null primitive type from a (possibly nullable) type
# field, as a length-1 character scalar. Normalizes list-vs-vector parsing.
.base_type <- function(node) {
      t <- unlist(node$type)          # list or vector -> character vector
      t <- t[t != "null"]             # drop the null marker if present
      if (length(t) != 1) {
            stop(
                  "Schema node has a 'type' this converter can't handle. Expected a single ",
                  "primitive type (optionally paired with \"null\"), but got: ",
                  paste(unlist(node$type), collapse = ", "),
                  ". Node description: ", node$description %||% "(none)"
            )
      }
      as.character(t)
}

# ==== $ref resolution ===========================================================
# Only local refs into $defs are supported, e.g. "#/$defs/scored_element".

.resolve_ref <- function(ref, defs) {
      if (!grepl("^#/\\$defs/", ref)) {
            stop("Unsupported $ref (only #/$defs/* is handled): ", ref)
      }
      key <- sub("^#/\\$defs/", "", ref)
      if (is.null(defs[[key]])) stop("$ref points to missing $def: ", key)
      defs[[key]]
}

# ==== Core recursive converter ==================================================
# node:     a JSON Schema (sub)node, as parsed by jsonlite (a named list)
# defs:     the top-level $defs table, for $ref resolution
# required: is this node required by its parent? -> ellmer required flag
# Returns:  an ellmer type_* object.

.convert_node <- function(node, defs, required = TRUE) {
      
      # Resolve $ref first; the referenced def carries the real shape. We keep the
      # caller's `required` (whether the *slot* is required), not the def's.
      if (!is.null(node[["$ref"]])) {
            node <- .resolve_ref(node[["$ref"]], defs)
      }
      
      nullable <- .is_nullable(node)
      # A field that is nullable OR not required becomes required = FALSE in ellmer.
      ell_required <- required && !nullable
      
      bt   <- .base_type(node)
      desc <- node$description %||% ""
      
      if (bt == "object") {
            req_names <- node$required %||% character(0)
            props     <- node$properties
            if (is.null(props)) stop("object node has no properties: ", desc)
            
            args <- lapply(names(props), function(nm) {
                  .convert_node(props[[nm]], defs, required = nm %in% req_names)
            })
            names(args) <- names(props)
            
            # type_object(.description, !!!fields, .required = ...)
            do.call(type_object, c(list(.description = desc), args,
                                   list(.required = ell_required)))
            
      } else if (bt == "array") {
            items <- node$items
            if (is.null(items)) stop("array node has no items: ", desc)
            item_type <- .convert_node(items, defs, required = TRUE)
            type_array(item_type, description = desc, required = ell_required)
            
      } else if (bt == "string") {
            type_string(description = desc, required = ell_required)
            
      } else if (bt == "integer") {
            type_integer(description = desc, required = ell_required)
            
      } else if (bt == "number") {
            type_number(description = desc, required = ell_required)
            
      } else if (bt == "boolean") {
            type_boolean(description = desc, required = ell_required)
            
      } else {
            stop("Unsupported JSON Schema type: '", bt, "' (desc: ", desc, ")")
      }
}

# ==== Public entry point ========================================================
# Reads schema.json from disk and returns the ellmer type_object for the root.

load_coding_schema <- function(schema_path) {
      if (!file.exists(schema_path)) stop("Schema file not found: ", schema_path)
      schema <- jsonlite::fromJSON(schema_path, simplifyVector = FALSE)
      defs   <- schema[["$defs"]] %||% list()
      .convert_node(schema, defs, required = TRUE)
}

# ==== Usage =====================================================================
# coding_schema <- load_coding_schema("artifacts/schema.json")
#
# Sanity-check before a real run — print it and eyeball the structure:
#   str(coding_schema, max.level = 3)
#
# NOTE ON ellmer API: type_object()'s argument for the required flag is .required
# in current ellmer; older versions used different conventions and type_array()'s
# signature has also shifted. If construction errors, check ?ellmer::type_object
# and ?ellmer::type_array in your installed version and adjust the do.call /
# type_array lines above. This is the most version-sensitive file in the project.
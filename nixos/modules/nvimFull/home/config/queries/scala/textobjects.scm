(class_definition
  body: (template_body)? @class.inner) @class.outer

(object_definition
  body: (template_body)? @class.inner) @class.outer

(function_definition
  body: [
    (indented_block)
    (expression)
    (indented_cases)
    (block)
  ] @function.inner) @function.outer

(parameter
  name: (identifier) @parameter.inner) @parameter.outer

(arguments (_) @parameter.inner) @parameter.outer

(class_parameter
  name: (identifier) @parameter.inner) @parameter.outer

(case_clause
  body: (_) @conditional.inner) @conditional.outer

(comment) @comment.outer

(val_definition
  value: (_)? @function.inner) @function.outer

(var_definition
  value: (_)? @function.inner) @function.outer

(generic_type 
  type: (type_identifier) 
  type_arguments: (_)?) @type.outer


(type_identifier) @type.inner


find . -type f -name \*.rb -print0 | xargs -0 cat  | \
tr '.' ' ' | \
tr '(' ' ' | \
tr ')' ' ' | \
tr '[' ' ' | \
tr ']' ' ' | \
tr '{' ' ' | \
tr '}' ' ' | \
tr '!' ' ' | \
tr '@' ' ' | \
tr '#' ' ' | \
tr ':' ' ' | \
tr '=' ' ' | \
tr '-' ' ' | \
tr '+' ' ' | \
tr '>' ' ' | \
tr '<' ' ' | \
tr '?' ' ' | \
tr '|' ' ' | \
tr '"' ' ' | \
tr ',' ' ' | \
tr '/' ' ' | \
tr '\' ' ' | \
tr "'" ' ' | \
tr ' ' '\n' | \
tr 'A-Z' 'a-z' | \
sort | \
uniq -c | sort -rn | head -n 70 | more

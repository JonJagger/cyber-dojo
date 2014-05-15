find . -type f -name \*.rb -print0 | xargs -0 cat  | \
tr '_' ' ' | \
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
sed 's/^end$/xx/' | \
sed 's/^if$/xx/' | \
sed 's/^def$/xx/' | \
sed 's/^print$/xx/' | \
sed 's/^puts$/xx/' | \
sed 's/^false$/xx/' | \
sed 's/^do$/xx/' | \
sed 's/^return$/xx/' | \
sed 's/^n$/xx/' | \
sed 's/^require$/xx/' | \
sed 's/^ruby$/xx/' | \
sed 's/^true$/xx/' | \
sed 's/^class$/xx/' | \
sed 's/^this$/xx/' | \
sed 's/^in$/xx/' | \
sed 's/^d$/xx/' | \
sed 's/^that$/xx/' | \
sed 's/^for$/xx/' | \
sed 's/^nil$/xx/' | \
sed 's/^private$/xx/' | \
sed 's/^as$/xx/' | \
sed 's/^module$/xx/' | \
sed 's/^each$/xx/' | \
sed 's/^be$/xx/' | \
sed 's/^i$/xx/' | \
sed 's/^by$/xx/' | \
sed 's/^0$/xx/' | \
sed 's/^1$/xx/' | \
sed 's/^of$/xx/' | \
sed 's/^a$/xx/' | \
sed 's/^is$/xx/' | \
sed 's/^else$/xx/' | \
sed 's/^are$/xx/' | \
sed 's/^the$/xx/' | \
sed 's/^and$/xx/' | \
sed 's/^to$/xx/' | \
sed 's/^not$/xx/' | \
sed 's/^argv0$/xx/' | \
sed 's/^7$/xx/' | \
sed 's/^2$/xx/' | \
sort | \
uniq -c | sort -rn | head -n 70 | more



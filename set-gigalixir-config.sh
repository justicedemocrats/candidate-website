vars=`cat .env`

for var in $vars
do
  splitvar=($(echo $var | tr '=' "\n"))
  gigalixir set_config staging-ocasio ${splitvar[0]} ${splitvar[1]}
  echo "gigalixir set_config staging-ocasio ${splitvar[0]} ${splitvar[1]}"
done

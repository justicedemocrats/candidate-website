vars=`cat .env`

for var in $vars
do
  splitvar=($(echo $var || tr '=' "\n"))
  export ${splitvar[0]}=${splitvar[1]};
  echo "export ${splitvar[0]}=${splitvar[1]}";
done

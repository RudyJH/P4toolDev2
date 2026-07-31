# script to backup and load to-be PPP data into postgres database
# from the net. was for taxes...


declare -i tax_year=1992
declare -i current_year=$(date +%Y)+1


read -p "Postgress user name: " nm
read -s -p "Postgress user password: " answer

export PGUSER=$nm
export PGPASSWORD=$answer


echo "Current Year  $current_year"

#
#   With needed parameters setup and environment verified
#   delcare all functions which will be used later on.
#
function ppp_db_open_error {
    echo "creating database"
    createdb  tax_$tax_year 'Tax information for $tax_year'
    psql  -q -d tax_$tax_year -f create_tax_tables.sql
    echo "database created"
}

echo ";;;;;"
echo ";;;;;"
echo ";;;;;         Copying csv files to /tmp"
echo ";;;;;"
echo ";;;;;"
cp -f -v ~/postgres_tax_backups/*.csv /tmp
chmod a+r /tmp/*.csv

while [ $tax_year -lt $current_year ]
do
    echo ";;;;;"
    echo ";;;;;"
    echo ";;;;;   Loading $_year"
    echo ";;;;;"
    echo ";;;;;"

    old_error_trace=$(set +o | grep errtrace)       # keep track of old error traps
    set -o errtrace
    trap tax_db_open_error ERR                       # setup trap for open error

    echo "creating tax tables"
    psql  -q -f create_tax_tables.sql tax_$tax_year

    trap - ERR                                      # reset ERR trap

    echo "copy payees from '/tmp/tax_${tax_year}_payees.csv' csv header;" > import_it.sql
    echo "copy categories from '/tmp/tax_${tax_year}_categories.csv' csv header;" >> import_it.sql
    echo "copy expenses from '/tmp/tax_${tax_year}_expenses.csv' csv header;" >> import_it.sql
    echo "   Importing ...  $tax_year"
    psql  -q -f import_it.sql tax_$tax_year
    psql  -q -d tax_$tax_year -c "select setval( 'expenses_tran_id_seq', (select max(tran_id) from expenses)+100);"

    let "tax_year += 1"
done


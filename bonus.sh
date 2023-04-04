#!/bin/bash

#the following lines declare the average price of cars being sold
merc_a_class_average=31095
merc_b_class_average=33162
merc_c_class_average=42537
merc_e_class_average=54437
amg_c65_average=79660

echo ""
echo "******This program calculates the employee's salary with tax******"
echo ""

#initialise the constant variables that are used as an array, counter and repeat variable.
count=0
input="y"
emp_list=()
while [ $count -lt 3 ] || [ $count -lt 20 ] && [ "$input" == "y" ]
do

echo ""

#we read the employees name making sure they are letters only 
read -p "What is the name of the employee? " empName

if [[ ! $empName =~ ^[a-zA-Z]+$ ]]
then
    echo "Name can only contain letters."
    continue
fi

#we then read the month we are calculating for while making sure it is in letters only 
read -p "What month would you like to calculate $empName's salary? " month

if [[ ! $month =~ ^[a-zA-Z]+$ ]]
then
    echo "Month can only contain letters."
    continue
fi

#the lines below are now asking (using the variables declared above) how many of each model did the employee sell during the month and storing them in the corresponding variables while also validating the data to be numbers only
read -p "How many A Class cars did $empName sell during $month? " a_class
if ! [[ $a_class =~ ^[0-9]+$ ]]; then
    echo "The input must be a number."
    continue
fi
read -p "How many B Class cars did $empName sell during $month? " b_class
if ! [[ $b_class =~ ^[0-9]+$ ]]; then
    echo "The input must be a number."
    continue
fi
read -p "How many C Class cars did $empName sell during $month? " c_class
if ! [[ $c_class =~ ^[0-9]+$ ]]; then
    echo "The input must be a number."
    continue
fi
read -p "How many E Class cars did $empName sell during $month? " e_class
if ! [[ $e_class =~ ^[0-9]+$ ]]; then
    echo "The input must be a number."
    continue
fi
read -p "How many AMG C65 cars did $empName sell during $month? " amg_c65
if ! [[ $amg_c65 =~ ^[0-9]+$ ]]; then
    echo "The input must be a number."
    continue
fi

#calculations for the sales (multiplying the number entered for each car above with the average of the cars respectively and adding them all together)
total_sales=$((a_class * merc_a_class_average + b_class * merc_b_class_average + c_class * merc_c_class_average + e_class * merc_e_class_average + amg_c65 * amg_c65_average ))

#this series of if statements begin assigning the bonus values based off the total sales of the employee
if [ $total_sales -ge 650000 ]
then
    emp_bonus=30000
elif [ $total_sales -ge 500000 ]
then
    emp_bonus=25000
elif [ $total_sales -ge 400000 ]
then
    emp_bonus=20000
elif [ $total_sales -ge 300000 ]
then
    emp_bonus=15000
elif [ $total_sales -ge 200000 ]
then
    emp_bonus=10000
else
    emp_bonus=0
fi

#the salary before tax is the amount the employee would have gotten which is the bonus plus the basic 2000 salary - max 32,000
salary_before_tax=$(( emp_bonus + 2000 ))

#tax check eligabliity- only if total sales is 12501 minimum would it allow tax to be calculated
if [ $salary_before_tax -gt 12500 ]
then
#this is the amount that is taxable which is 20% of the salary before the tax
taxable_amount=$(awk "BEGIN {print $salary_before_tax * 0.2}" )

#this calculation takes the salary before tax and removes from it the taxable amount
salary_after_tax=$(( salary_before_tax - taxable_amount ))
else
#otherwise, the salaray remains the same
salary_after_tax=$salary_before_tax
fi

#sort employees in the array 
employee_list+=("$empName $month $total_sales $salary_before_tax $salary_after_tax")



#this displays the result on the terminal
echo "$empName's salary before tax is £$salary_before_tax and after tax, their net salary is £$salary_after_tax for $month"

#if the directory doesnt exist along with the file name, it makes it
if [[ ! -e ~/21411086/as2/emp_salaries.txt ]];
then
mkdir -p ~/21411086/as2
touch ~/21411086/as2/emp_salaries.txt
fi

#however this code adds the same data into the file called emp_salaries.txt in the directory
echo "$empName's salary before tax is £$salary_before_tax and after tax, their net salary is £$salary_after_tax for $month" >> ~/21411086/as2/emp_salaries.txt

#allow for loop of the program using the counter variable while making sure the condition is valid
count=$((count+1))
  if [ $count -lt 20 ] && [ $count -ge 3 ]
  then
    read -p "Enter data for another employee? (y/n) " input
  fi
done
#sorting the employee data using bubble sort
for i in "${!employee_list[@]}";
do
for j in "${!employee_list[@]}";
do
if [[ "${employee_list[i]}" < "${employee_list[j]}" ]];
then
#swapping the values
temp="${employee_list[i]}"
employee_list[i]="${employee_list[j]}"
employee_list[j]="$temp"
fi
done
done

#printing the sorted employee data
echo ""
echo "Name, Month, total sales, salary before tax, salary after tax"
echo ""
for i in "${employee_list[@]}";
do
echo "$i"
done

#exiting the script
exit 0
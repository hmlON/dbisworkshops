from django.shortcuts import render
from django import forms
from django.db import connection

def index(request):
    return render(request, 'pages/index.html')


class SalaryForm(forms.Form):
    from_salary = forms.FloatField(required=False, min_value=0, max_value=10000000)

def salaries(request):
    form = SalaryForm(request.GET)
    from_salary = request.GET.get('from_salary')

    cursor = connection.cursor()
    cursor.execute("select * from table(salaries.users_with_salary_bigger_than(:salary))", {'salary': from_salary})
    salaries = cursor.fetchall()

    headers = ('name', 'salary')
    salaries = [dict(zip(headers, salary)) for salary in salaries]

    return render(request, 'pages/salaries.html', {'salaries': salaries, 'from_salary': from_salary, 'form': form})

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 20 23:54:20 2024

@author: Oliver Dai
"""
!pip install sympy
!pip install scipy
from scipy.optimize import minimize

# Define the function to maximize
def obj_func(variables):
    x, y = variables
    C_0 = 80000 - ((x - 1.5) / 0.1) * 5000 - ((y - 250) / 100) * 1000
    C_1 = 350 - ((y - 250) / 100) * 50  
    R = (x * C_0 + y * C_1)    
    return -R

# Initial guess
initial_guess = [1.5, 250]

# Define bounds for variables
bounds = ((1.5, 16), (0, 1000))

# Use the minimize function to find the maximum
result = minimize(obj_func, initial_guess, bounds=bounds)

# Extract the optimal values of x and y
x_optimal, y_optimal = result.x

# Calculate the maximum value of z
z_max = -result.fun

# Print the results
print("Optimal values:")
print("x =", x_optimal)
print("y =", y_optimal)
print("Maximum value of z =", z_max)



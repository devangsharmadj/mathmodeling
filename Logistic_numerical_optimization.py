import numpy as np
from scipy.optimize import minimize

def C_0(x, y):
    return 160000 - (160000 / (1 + np.exp(-0.5*(x - 1.5)))) - ((y - 250) / 100) * 1000

def C_1(x, y):
    return 700 - (700 / (1 + np.exp(-0.01* (y - 250))))

def objective(vars):
    x, y = vars
    return -(x * C_0(x, y) + y * C_1(x, y))  # Negate Z to maximize it using a minimization function

# Initial guesses for x and y
initial_guess = [10, 300]

# Bounds for x and y, assuming some reasonable ranges
bounds = [(0, 1000), (0, 1000)]  # Modify as needed based on the problem's context

# Perform the optimization
result = minimize(objective, initial_guess, bounds=bounds)

# Output the results
optimized_x, optimized_y = result.x
max_Z = -result.fun  # Negate again to get max Z
print(f"Optimal x: {optimized_x}")
print(f"Optimal y: {optimized_y}")
print(f"Maximized Objective Function: {max_Z}")

"""
Result:
Optimal x: 2.974550611131228
Optimal y: 218.97158696272078
Maximum Z: 243369.07260973746
"""

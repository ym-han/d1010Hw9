#import Pkg
#Pkg.add("Polynomials")
#Pkg.add("Statistics")
#using Test, Plots, LaTeXStrings, Polynomials, Statistics

pyplot(fontfamily = "Palatino", size = (400, 250), fmt = :svg);

"""
Return the vector obtained by replacing the first 
k values with their average and the remaining values
with their average
"""
function decision_stump_fit(y, k)
    return vcat([mean(y[1:k]) for _ in 1:k], [mean(y[k+1:end]) for _ in k+1:length(y)]) 
end

@test decision_stump_fit([2, 2, 5, 5, 5], 3) ≈ [3, 3, 3, 5, 5]


"""
Return the best decision stump fit, by mean squared error
"""

#=
* For each possible split k, the function which minimizes 
the mean squared error is that which, for each of the two k-partitions, 
is piecewise constant at the mean of (the response values of) 
the data points at that partition. (since the mean of the response values
minimizes the mean squared error for that partition). 

* And the function (in code) above, decision_stump_fit(y, k), 
in effect gives us the pointwise MSE-minimizing function for each k.

* So, to find the split k_min which minmizes MSE the most,
we can 

1. 
a. Call  decision_stump_fit(y, k) for each possible value of k;
b. record the total MSE for each such fit
c. find the k which min total MSE the most

=#
function decision_stump_fit(y)
    mse(ŷ) = sum((y - ŷ).^2) # def ftn mse
    
    listYHats = [decision_stump_fit(y, k) for k in 1:length(y)] #1a
    min_value, min_index = findmin([mse(y_hat) for y_hat in listYHats])
    return min_index
    
end


decision_stump_fit([1, 2, 1, 5, 5])

#@test decision_stump_fit([1, 2, 1, 5, 5]) ≈ [4/3, 4/3, 4/3, 5, 5]
#=
y = [1, 2, 1, 5, 5]
listYHats = [decision_stump_fit(y, k) for k in 1:length(y)]=#
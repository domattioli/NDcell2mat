# NDcell2mat
Convert cell arrays, itself composed of numeric arrays of any size, into a larger matrix with filler values to accomodate incongruent sizes, which MATLAB's built-in 'cell2mat()' function does not accomodate.
Note: the function *reshapes* the numeric arrays into vectors along the first scalar dimension of the cell array.

[![View NDcell2mat on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/94240-ndcell2mat)

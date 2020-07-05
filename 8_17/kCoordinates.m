function [kRows,kCols] = kCoordinates(row,col)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if row == 1 && col == 1
        kRows = [0 0 16];
        kCols = [0 16 0];
    elseif row == 1 && col > 1
        kRows = [0 0 0 16];
        kCols = [0 16 16 0];
    elseif row > 1 && col == 1
           kRows = [0 -16 0 16];
           kCols = [0 0 16 0];
    elseif row == 16 && col == 16
        kRows = [0 -16 0];
        kCols = [0 0 -16];
    elseif row == 16 && col < 16
        kRows = [0 -16 0 0];
        kCols = [0 0 -16 16];
    elseif row < 16 && col == 16
        kRows = [0 -16 0 16];
        kCols = [0 0 -16 0];
    else
        kRows = [0 -16 0 0 16];
        kCols = [0 0 -16 16 0];
    end
end


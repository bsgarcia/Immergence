function color = findColor(this, type, frenchText)
    if nargin < 3;
        frenchText = 0;
    end;
    idx = find(strcmp([this.possibleColors], type));
    color = this.colors(idx, :);
    if frenchText;
        color = this.frenchPossibleColors{idx};
    end;
end
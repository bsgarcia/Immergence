function cell2excel(matfile, dataname)
    %
    if nargin < 2;
        dataname = 'hdata';
    end;
    load(matfile);
    eval(['datamat=', dataname, ';']);
    variables = datacell2set(datamat);
    export(variables, 'XLSfile', matfile);

end

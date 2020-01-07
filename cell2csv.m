function cell2csv(filename, c, varargin)

    % cell2csv(filename, c, sep, prot, row, col, rowsep)
    %
    % Write a cell array to a CSV file.
    %
    % filename - the output filename (it will be overwritten if it exists)
    % c        - the cell array to write
    % sep      - (optional) a separator to use between the cells, default: ','
    % prot     - (optional) a record protector character to allow the separator
    %            to be within a cell, default: '"'
    % row      - (optional) the first row to write, default: 1
    % col      - (optional) the first column to write, default: 1
    % rowsep   - (optional) the row separator (it is evaluated with sprintf
    %            before use), default: '\r\n'
    %
    % Example:
    % cell2csv('test.csv', mycellarray)

    %%%%%
    % Process the input arguements
    %%%%%

    if (length(size(c)) > 2)
        error('cell2csv: Only two dimensional cell arrays are supported');
    end

    if (length(varargin) < 1)
        varargin{1} = ',';
    end
    if (length(varargin) < 2)
        varargin{2} = '"';
    end
    if (length(varargin) < 3)
        varargin{3} = 1;
    end
    if (length(varargin) < 4)
        varargin{4} = 1;
    end
    if (length(varargin) < 5)
        varargin{5} = '\r\n';
    end

    sep = varargin{1};
    prot = varargin{2};
    row = varargin{3} - 1;
    col = varargin{4} - 1;
    rowsep = sprintf(varargin{5});

    if (length(sep) > 1)
        error('cell2csv: The separator must be one character')
    end
    if (length(prot) > 1)
        error('cell2csv: The record protector must be one character')
    end

    %%%%%
    % Do stuff
    %%%%%

    [fid, errmsg] = fopen(filename, 'a+');
    if (fid == -1)
        error('cell2csv: Unable to open %s: %s\nIt is probably open somewhere on your computer.', filename, errmsg);
    end

    for i = 1:row
        fprintf(fid, rowsep);
    end

    for i = 1:size(c, 1)
        % write every row
        for k = 1:col
            fprintf(fid, sep);
        end

        for j = 1:size(c, 2)
            % write every column
            if isnumeric(c{i, j})
                if (prod(size(c{i, j})) > 1)
                    error('cell2csv: Elements of the array must be single numbers not matrices in (%g,%g)', i, j);
                end
                thistext = sprintf('%1.15e', c{i, j});
            else
                switch class(c{i, j})
                    case 'char'
                        if (size(c{i, j}, 1) > 1)
                            error('cell2csv: Only single line strings are allowed in (%g,%g)', i, j);
                        end
                        thistext = c{i, j};
                    case 'cell'
                        error('cell2csv: Subcells are not allowed in (%g,%g)', i, j);
                    otherwise
                        error('cell2csv: Unhandled class in (%g,%g)', i, j);
                end
            end

            % handle escaping the characters as necessary
            foundprots = strfind(thistext, prot);
            if isempty(foundprots)
                if (~isempty(strfind(thistext, sep)))
                    thistext = [prot, thistext, prot];
                end
            else
                for k = length(foundprots):-1:1
                    thistext = [thistext(1:foundprots(k)-1), prot, prot, thistext(foundprots(k)+1:end)];
                end
                thistext = [prot, thistext, prot];
            end

            % write the text to the file
            if (j == 1)
                fprintf(fid, '%s', thistext);
            else
                fprintf(fid, '%s%s', sep, thistext);
            end
        end
        fprintf(fid, rowsep);
    end

    fclose(fid);

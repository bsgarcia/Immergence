function [variables varnamescell]=datacell2set(hdata)
s=size(hdata);
hmat=hdata(2:s(1),:);
hnames=hdata(1,:)';
variables=dataset({hmat,hnames{:}});
varnamescell=hnames;
varnames=char(hnames);
for i=1:s(2)
    if (ischar(hmat{1,i}) || strcmp(hnames{i},'proportionKey'));
        %eval(['variables.' varnames(i,:) '=char(variables.' varnames(i,:) ');']); %transforms text cell to char, use x.var(n,:) instead of x.var(n) or x.var{n} to get a full word
    else 
        eval(['variables.' varnames(i,:) '=cell2mat(variables.' varnames(i,:) ');']);
    end
end
end
function [newStructure nObs]=filterStruct(struct,condition)
%example : [lastRoundVars nObs]=filterStruct(variables,'struct.lastRound==1');
eval(['newStructure = structfun(@(x) x(' condition '), struct, ''UniformOutput'', false);']);
fnames=fieldnames(newStructure); eval(['x=newStructure.' fnames{1} ';']);
nObs=length(x);
end
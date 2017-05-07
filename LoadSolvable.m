function solvable=LoadSolvable(filename)
data=importdata(filename);
textdata=data.textdata;
datalength=size(textdata,1);
solvable=zeros(1,datalength);
for i=1:datalength
    if strcmp('feasible',textdata{i,3})==1
        solvable(i)=1;
    end
end
end
function WriteIntoText(results,filename)
datalength=length(results);
f=fopen(filename,'a');
for i=1:datalength
    if length(results{i})==0
        fprintf(f,int2str(i));
        fprintf(f,'\r\n');
    else
        fprintf(f,int2str(i));
        fprintf(f,'\t');
        fprintf(f,num2str(results{i}.bestObj_hist));
        fprintf(f,'\r\n');
    end
end
fclose(f);
end
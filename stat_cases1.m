for i=1:4400
    c=split(f{i},'/');
    c=c{2};
    s=split(c,'_');
    c=s{2};
    c=str2num(c(2));
    m=s{3};
    m=str2num(m(2:3));
    m=m/5;
    n=s{1};
    s=str2num(n);
    s=ceil(s/30);
    ma(s,m+3*(c-1))=ma(s,m+3*(c-1))+1;
end
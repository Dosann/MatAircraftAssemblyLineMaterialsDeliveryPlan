function DeleteCasesByM(folder,Ms)
% ɾ��ĳ���ļ���������mֵ������Ms�е�Case
dirs=dir(folder);
for i=3:length(dirs)
    files=dir([folder,'/',dirs(i).name,'/']);
    for j=3:length(files)
        name=files(j).name;
        m=split(name,'_');
        m=m{3};
        m=str2num(m(2:3));
        if ismember(m,Ms)
            delete([files(j).folder,'/',name]);
        end
    end
end
function [ output_args ] = find_spt2()
%FIND_SPEED_DELTAF �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
file = dir('*ANA*cue*.mat');

for i = 1:length(file)
    cName = file(i).name
    temp = importdata(cName);
    data_filename = ['rb14',cName];
    save(data_filename,'-struct','temp');

end


end


function auc = aucCal(x,win,varargin)
auc = nan(size(varargin{1},1),length(varargin));
if ~isempty(varargin)
    dt = x(2) - x(1);
    idxMin = find(x == win(1));
    idxMax = find(x == win(2));
    for j = 1:1:length(varargin)
        data = varargin{j};
        cdata = data(:,idxMin:idxMax);
        cauc = sum(cdata,2)*dt;
        auc(:,j) = cauc;
    end
end
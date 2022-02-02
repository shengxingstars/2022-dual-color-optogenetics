function normdata = normData(data)
pv = max(data,[],2);
normdata = bsxfun(@rdivide,data,pv); 
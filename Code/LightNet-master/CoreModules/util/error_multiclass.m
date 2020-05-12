% -------------------------------------------------------------------------
function err = error_multiclass(labels, res)
% -------------------------------------------------------------------------
predictions = gather(res(end-1).x) ;
if length(size(predictions))==4
    predictions=permute(predictions,[3,4,1,2]);
end
[~,predictions] = sort(predictions, 1, 'descend') ;

% be resilient to badly formatted labels
if numel(labels) == size(predictions, 2)
  labels = reshape(labels,1,[]) ;
end

error = ~(predictions==labels) ;
error=gather(error);
err(1,1) = sum(error(1,:)) ;
if size(error,1)>=5
err(2,1) = sum(min(error(1:5,:),[],1)) ;
else
    err(2,1)=sum(min(error(1:end,:),[],1)) ;
end
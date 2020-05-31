layer = averagePooling2dLayer(2,'Name','avg1')
layer = averagePooling2dLayer(2,'Stride',2)
layer = averagePooling2dLayer([3 2],'Stride',2)
%An average pooling layer performs down-sampling by dividing the input into rectangular pooling regions and computing the average values of each region.
%
%Pooling layers follow the convolutional layers for down-sampling, hence, reducing the number of connections to the following layers. They do not perform any learning themselves, but reduce the number of parameters to be learned in the following layers. They also help reduce overfitting.
%
%An average pooling layer outputs the average values of rectangular regions of its input. The size of the rectangular regions is determined by the poolSize argument of averagePoolingLayer. For example, if poolSize is [2,3], then the layer returns the average value of regions of height 2 and width 3.
%
%Pooling layers scan through the input horizontally and vertically in step sizes you can specify using the 'Stride' name-value pair argument. If the pool size is smaller than or equal to the stride, then the pooling regions do not overlap.
%
%For nonoverlapping regions (Pool Size and Stride are equal), if the input to the pooling layer is n-by-n, and the pooling region size is h-by-h, then the pooling layer down-samples the regions by h [1]. That is, the output of a max or average pooling layer for one channel of a convolutional layer is n/h-by-n/h. For overlapping regions, the output of a pooling layer is (Input Size ¨C Pool Size + 2*Padding)/Stride + 1.

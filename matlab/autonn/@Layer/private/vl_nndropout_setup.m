function inputs = vl_nndropout_setup(layer)
%VL_NNDROPOUT_SETUP
%   Setup a dropout layer, by adding a mask generator layer as input.
%   Called by AUTONN_SETUP.

% Copyright (C) 2016 Joao F. Henriques.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

  assert(isequal(layer.func, @vl_nndropout)) ;
  
  inputs = layer.inputs ;

  % parse dropout rate
  rate = 0.5 ;
  if numel(inputs) >= 3 && strcmp(inputs{2}, 'rate')
    rate = inputs{3} ;
    inputs(2:3) = [] ;
  end
  
  % create mask generator
  maskLayer = Layer(@vl_nnmask, inputs{1}, rate) ;
  inputs = [inputs, {'mask', maskLayer}] ;
  
  % vl_nndropout doesn't return a derivative for the mask
  layer.numInputDer = 1 ;
  
  % remove layer in test mode
  layer.testFunc = 'none' ;

end

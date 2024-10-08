function out = wrapper_Guide(in,Guide_in,sigma)
 out = imguidedfilter(in, Guide_in,'NeighborhoodSize',[3,3],'DegreeOfSmoothing', sigma*255);
end
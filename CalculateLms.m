function lms=CalculateLms()
global Case Paras

lms=ceil(Case.position'+((Case.a+Case.b)/2)'*Paras.v);
end
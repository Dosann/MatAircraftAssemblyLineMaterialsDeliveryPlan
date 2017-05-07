function DrawCuboid(x0,y0,z0,xl,yl,zl,status)
if status==1
    [x,y,z]=meshgrid([x0,x0+xl],[y0,y0+yl],[20-zl,20]);
    fun=20*ones(2,2,2);
    slice(x,y,z,fun,[x0,x0+xl],[y0,y0+yl],[20-zl,20]);
else
    [x,y,z]=meshgrid([x0,x0+xl],[y0,y0+yl],[z0,z0+zl]);
    fun=(x+y+z)/200;
    slice(x,y,z,fun,[x0,x0+xl],[y0,y0+yl],[z0,z0+zl]);
end

% x=[x0,x0,x0,x0,x0+xl,x0+xl,x0+xl,x0+xl];
% y=[y0,y0+yl,y0+yl,y0,y0,y0+yl,y0+yl,y0];
% z=[z0,z0,z0+zl,z0+zl,z0,z0,z0+zl,z0+zl];
% mesh(x,y,z);

end
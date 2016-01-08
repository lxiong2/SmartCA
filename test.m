dbusP = busP(:,3) - busP(:,2);

newthetaD = ((thetaD*2*pi/360)+invBp*dbusP)*360/(2*pi);
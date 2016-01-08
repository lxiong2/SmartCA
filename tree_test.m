clc

newTree = tree('S0: 23-Oct-2013 8:50')

[newTree n01] = newTree.addnode(1,'S1: 23-Oct-2013 8:55')
[newTree n02] = newTree.addnode(1, {lineStatus})
[newTree n03] = newTree.addnode(1, netgens)
[newTree n04] = newTree.addnode(1, netloads)

% 
% [newTree n2] = newTree.addnode(1, flagged(:,:,2))
% [newTree n3] = newTree.addnode(1, flagged(:,:,3))

% content1 = newTree.get(n01)
% content2 = newTree.get(n02)
% content3 = newTree.get(n03)
% content4 = newTree.get(n04)

[newTree n011] = newTree.addnode(n01,'S2: 23-Oct-2013 9:00')
[newTree n012] = newTree.addnode(n01, {lineStatus})
[newTree n013] = newTree.addnode(n01, [busGen(:,1) busGen(:,2)])
[newTree n014] = newTree.addnode(n01, [busLoad(:,1) busLoad(:,2)])
[newTree n015] = newTree.addnode(n01, [busLoad(:,1) busLoad(:,2)])
[newTree n016] = newTree.addnode(n01, flagged(:,:,1))

disp(newTree.tostring)

newTree.getparent(n011)

%工具包：shortestpath：两个单一节点之间的最短路径-Dijkstura算法
%时间：2020.12.25
clc
clear
s=[1,1,1,2,2,3,3,4,4,4,5,5,6,6,7]; %编号
t=[2,3,4,4,5,4,7,5,6,7,6,8,7,8,8]; %能走的下一个编号
w=[1,7,1,8,1,1,1,18,1,1,1,12,1,15,1]; %距离
G= digraph(s,t,w); %做有向图
plot(G,'EdgeLabel', G.Edges.Weight,'linewidth',2);
set(gca,'XTick',[],'YTick',[] ) ;
figure(1)
[P,d] = shortestpath(G,1,8); %注意:该函数matlab2015b之后才有
%在图中高亮我们的最短路径
myplot = plot(G,'EdgeLabel',G.Edges.Weight,'linewidth',2); %首先将图赋给一个变量
highlight (myplot,P,'EdgeColor','r');%对这个变量即我们刚刚绘制的图形进行高亮处理，红色显示最短路径
title('最短路径')

figure(2)
s = [1 1 1 2 2 6 6 7 7 3 3 9 9 4 4 11 11 8];
t = [2 3 4 5 6 7 8 5 8 9 10 5 10 11 12 10 12 12];
weights = [10 10 10 10 10 1 1 1 1 1 1 1 1 1 1 1 1 1];
G = graph(s,t,weights);
plot(G,'EdgeLabel',G.Edges.Weight)
[P,d] = shortestpath(G,3,8)

%shortestpathtree
%从节点的最短路径树
%有向图和无向图、网络分析
% 表示网络连接的图形，该类图形广泛应用于各种物理、生物和信息系统。您可以使用图形表示大脑中的神经元、
% 航空公司的飞行模式及更多领域的相关内容。图形的结构由“节点”和“边”组成。每个节点表示一个实体，
% 每个边表示两个节点之间的连接。有关详细信息，请参阅有向图和无向图。

%可视化广度优先搜索和深度优先搜索
% 此示例说明如何定义这样的函数：该函数通过突出显示图的节点和边来显示 bfsearch 和 dfsearch 的可视化结果。
% 
% 创建并绘制一个有向图。

s = [1 2 3 3 3 3 4 5 6 7 8 9 9 9 10];
t = [7 6 1 5 6 8 2 4 4 3 7 1 6 8 2];
G = digraph(s,t);
plot(G)

% 对该图执行深度优先搜索。指定 'allevents' 以便在算法中返回所有事件。此外，将 Restart 指定为 true 以确保搜索会访问图中的每个节点。

T = dfsearch(G, 1, 'allevents', 'Restart', true)
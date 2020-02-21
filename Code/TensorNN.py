from tensornetwork import ncon
import numpy as np
import tensornetwork as tn

#
a = np.ones((2, 2))
b = np.ones((2, 2))
c = ncon([a, b], [(-1, 1), (1, -2)])
print(c)

# Create the nodes
a = tn.Node(np.ones((10,)))
b = tn.Node(np.ones((10,)))
edge = a[0] ^ b[0] # Equal to tn.connect(a[0], b[0])
final_node = tn.contract(edge)
print(final_node.tensor) # Should print 10.0


# Create the nodes
a = tn.Node(np.ones((10,)))
b = tn.Node(np.ones((10,)))
edge = a[0] ^ b[0] # Equal to tn.connect(a[0], b[0])
final_node = tn.contract(edge)
print(final_node.tensor) # Should print 10.0

#
a = tn.Node(np.zeros((1, 2, 3)))
e1 = a[0]
e2 = a[1]
e3 = a[2]
a.reorder_edges([e3, e1, e2])
#print(a.reorder_edges)
# If you already know the axis values, you can equivalently do# a.reorder_axes([2, 0, 1])print(a.tensor.shape) # Should print (3, 1, 2)
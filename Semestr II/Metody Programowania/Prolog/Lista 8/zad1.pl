
leaf.
parenL -->['('],!.
parenP -->[')'],!.
tree(leaf) -->['*'],!.
tree(node(A, B)) -->
  parenL,
  tree(A),
  tree(B),
  parenP.

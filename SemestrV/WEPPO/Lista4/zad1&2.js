class Node{
  constructor(value, left = null, right = null) {
    this.value = value;
    this.left = left;
    this.right = right;
  }
}

Node.prototype[Symbol.iterator] = function* () {
  yield this.value;
  if (this.left) yield* this.left;
  if (this.right) yield* this.right;
}

let Tree = new Node(4,
  new Node(1, new Node(2), new Node(3)),
  new Node(1, new Node(2), new Node(3)))

for (var e of Tree) {
  console.log(e);
}
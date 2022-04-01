class BinaryTree
{
    Node root;

    public boolean checkSiblings(Node node, Node a, Node b)
    {
        if (node == null)
            return false;
        return ((node.left == a && node.right == b) ||(node.left == b && node.right == a) ||checkSiblings(node.left, a, b) || checkSiblings(node.right, a, b));
    }
 
    public int findlevel(Node node, Node nodePointer, int level)
    {
        if (node == null)
        {
            return 0;
        }
            
        if (node == nodePointer)
        {
            return level;
        }
            
        int l = findlevel(node.left, nodePointer, level + 1);
        if (l != 0){
            return l;
        }
        else {
            return findlevel(node.right, nodePointer, level + 1);
        }
            
    }
 
    public boolean checkCousins(Node node, Node a, Node b)
    {
        return ((findlevel(node, a, 1) == findlevel(node, b, 1)) && (!checkSiblings(node, a, b)));
    }
}
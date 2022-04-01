// Trent Hardy
// CS 3345 Assignment 2
// RemoveNthNode method

public Node removeNthNode(Node headPointer, int n)
{
    // Create a temporary node 
    Node tempNode = new Node;

    // Set the head of the tempNode to the head of the linkedlist given
    tempNode.next = headPointer;


    // Create two new nodes eqaul to the tempNode.
    Node first = tempNode;
    Node second = tempNode;


    // Loop through the nodes in the linkedlist
    for (int i = 1; i <= n + 1; i++)
    {
        // Set the first Node equal to the head of the next node. (the next value in linkedlist)
        first = first.next;
    }

    // Failsafe
    while (first != null)
    {
        // Set the first Node equal to the head of the next node. (the next value in linkedlist)
        first = first.next;
        // Set the second Node equal to the head of the next node. (the next value in linkedlist)
        second = second.next;
    }

    // Set the head of second to the head of the next value.
    // This is effectively removing Nth node from the end of the list
    second.next = second.next.next;

    // Return the new head of the linked list
    return tempNode.next;
}
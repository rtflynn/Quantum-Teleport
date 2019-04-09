# Quantum Teleportation
For a quick primer on quantum computing and the use of the Q# programming language, see https://blogs.msdn.microsoft.com/uk_faculty_connection/2018/02/06/a-beginners-guide-to-quantum-computing-and-q/ . I'll be assuming some small amount of comfort with the ideas laid out there.

The main idea of quantum teleportation is as follows:  Given two qubits q1 and q2 (not necessarily being held in the same location), transfer the state of q1 to q2.  We are allowed to prepare whatever quantum or classical states we want beforehand, and we are allowed to communicate any number of classical bits in order to transfer our state from q1 to q2.  We require that q1 and q2 do not end up entangled with each other, i.e. simply entangling q1 and q2 via "CNOT(q1, q2); Hadamard(q1);" doesn't count as a solution.  In other words, we'd like to be able to reset q1 after this process without affecting q2.

For ordinary bits, this would be no problem:  Simply read q1, send the information to the facility holding q2, and have someone at that facility set q2 to that value.  This won't work with a quantum system because to read q1 is to measure it, so if q1 were in some superposition of |0> and |1> and we measured q1 as |0>, then setting q2 to |0> would not be the same as setting q2 to the original state of q1.  Equally fundamentally, even if we did know the state of q1, unless q1 were particularly simple it could take an infinite number of classical bits to write this state down.  

It's worth mentioning the no-cloning theorem, which says that it's impossible to create a perfect copy of an unknown quantum state.  This implies that there's no way to solve this problem without somehow changing q1.  It implies a bit more - namely, if we could transfer the state of q1 to q2, then we can't in principle do anything to q1 to get it back to the state it used to be in without doing something to q2 which knocks it out of its new state.  This serves as a nice hint for how quantum teleportation might be done:  (1) Start out with q1 and q2, where q1 is in some unknown state and q2 is (crucially) in some known state.  (2) Mess around with entanglement and superposition a bit.  (3) End with q1 in a known state and q2 in the state q1 used to hold.


# Quick Review of States
Recall that a single qubit can be in the state   a|0> + b|1>  , where a and b are complex numbers whose squared magnitudes sum to 1 ( |a|^2 + |b|^2 = 1 ).  The numbers a and b are called amplitudes, and for a qubit in the state a|0> + b|1> the probability of measuring the qubit in (say) state |0> is |a|^2.

A two-qubit system is in some state a|00> + b|01> + c|10> + d|11>, where again a, b, c, d are complex numbers whose squared magnitudes sum to 1.  Again these coefficients are called amplitudes, and again their squared magnitudes give probabilities of measurements having certain outcomes.  So, for example, if we measure both qubits then we'll find that with probability |c|^2 the first qubit is measured as 1 and the second is measured as 0.

A general n-qubit system can be written and interpreted analagously.  

Once a qubit has been measured, its state 'collapses' to the state which was measured.  For example, suppose we somehow got a qubit to the state  0.6*|0> + 0.8*|1>, meaning that upon measurement we'd expect to see |0> with 36% probability and |1> with 64% probability.  Once we measure the qubit (let's say we read a '0'), its state collapses to the state  1*|0> + 0*|1>.  If we were to measure our qubit again, we'd get the same measurement with 100% probability.  


# Quick Review of Quantum Gates
We only need a few types of quantum gate for this project.  These are popular gates with lots of online references.

## 1-Qubit Gates
X Gate (also called NOT gate):  Sends |0> to |1>   and  |1> to |0>.  
Fleshed out a little more, this means that the X gate sends a qubit in state  a|0> + b|1> to the state b|0> + a|1>.  This linearity is a general feature of quantum gates - i.e. we can explain fully what a quantum gate does to a system just by specifying what it does to a chosen set of basis states.

![X Gate Circuit Diagram](/images/XGateDiagram.png)

Z Gate:   Sends |0> to |0>  and |1> to -|1>.  
Therefore Z sends a|0> + b|1> to a|0> - b|1>.  Note that this does not impact the probability of observing a given outcome because |b|^2 = |-b|^2.  Rather, the effects of a Z gate are seen after other gates have been applied.

![Z Gate Circuit Diagram](/images/ZGateDiagram.png)

Hadamard Gate:  Sends |0> to 1/sqrt(2) * (|0> + |1>)  and  |1| to 1/sqrt(2) * (|0> - |1>).
The main use of the Hadamard gate (at least in this project) is to take qubits which are in a classical state (for example, in the state |0>)  and to put them into a superposition.  If we begin with a qubit in state |0> and send it through the Hadamard gate, we get a qubit which has equal probability of being measured as 0 or 1.  (Neat!)

![Hadamard Circuit Diagram](/images/HadamardDiagram.png)

## 2-Qubit Gate
There are lots of 2-qubit gates, but we only make use of one particular type in this project.

CNOT Gate:  In principle it's only necessary to specify what this gate does on any basis state, so here goes:  The CNOT gate sends |00> to |00>, |01> to |01>, |10> to |11>, |11> to |10>  (and thus we can write down what the CNOT gate does to an arbitrary pair of qubits in any superposition).  

![CNOT Gate Circuit Diagram](/images/CNOTGateDiagram.png)

More intuitively, the CNOT gate performs a NOT operation on the second qubit if the first qubit has value 1.  This gets a little messy to think about, because we want to think about qubits as not having particular values until they're measured, and we certainly don't want our gates to be measuring anything!  So what's meant here is that the CNOT gate simply acts by the above mathematical definition - i.e. interchanges the amplitudes for the events |10> and |11>.  

CNOT stands for "Controlled NOT"; we often think of the first qubit as the "control bit" and the second qubit as the "target bit".  The main use of the CNOT gate (in this project) is to entangle two qubits.  

# Quick Review of Entanglement
We can entangle two quantum bits by use of the CNOT gate.  This is a point which is not made clearly enough in the beginner tutorials on the subject - i.e. it's usually stated, or at least suggested, that to create entanglement we need both a Hadamard gate and a CNOT gate arranged as in the image below:

![Entanglement Circuit Diagram](/images/EntanglementDiagram.png)

The truth is, the CNOT gate alone is enough to entangle two states, but for classical states |0> and |1> it's just not interesting to do so.  Let's take a look at the sense in which a CNOT gate creates entanglement.

![CNOT Circuit Diagram](/images/CNOTGateDiagram.png)

In the above, let's let the top qubit begin in state a|0> + b|1>  , and let the bottom qubit begin in state |0>.  So, before the CNOT gate, our system is in state  a|00> + b|10>  , which reflects the fact that the only possibility for our second qubit is state |0>.

After the CNOT (it's easy to verify on paper, and any beginners definitely should do so), the system is in state a|00> + b|11>.  That is, if we measure both qubits in any order, the only possibilities are (i) both qubits measure 0, or (ii) both qubits measure 1 (!).  That is, the two qubits are entangled.  Also note that the amplitudes haven't changed, so that now we can measure (say) the second qubit and it will behave the same as if we had decided to measure the first qubit.

## Creating Interesting Entangled States From Classical States
We already mentioned that Hadamard gates create superposition from less-interesting classical states, and that CNOT gates create entanglement.  We can therefore use these two types of gates together to manufacture interesting, entangled states from more classical states.

![Entanglement Circuit Diagram With States](/images/EntanglementWithStates.png)

For example, if we send in two classical qubits with value |0>, then after this pair of gates we've got an interesting system of two qubits, perfectly entangled, and equally likely to be measured as a pair of 0's or a pair of 1's.

## Teleporting a Qubit in the Same Room
Let's suppose we have some interesting qubit q1 in state  a|0> + b|1>  and some classical qubit q2 in state |0>.  How can we use quantum gates to turn this system into one where q1 is in a classical state and q2 is in state a|0> + b|1> ?  This is another nice beginner exercise, so give it a shot before reading on.

![Circuit Diagram for Teleportation](/images/TeleportSameRoom.png)

It can be quickly verified that this does what we want.  Let's step through gate by gate.

The system is originally in state  a|00> + b|10>.

After the CNOT gate, the system is in state  a|00> + b|11>.

After the Hadamard gate, the system is in state  1/sqrt(2) ( a|00> + a|10> + b|01> + b|11> ).

After measurement:

 - If 0:  Bottom qubit is in state  a|0> + b|1>

 - If 1:  Bottom qubit is in state  a|0> + b|1>


## Teleporting a Qubit Across a Vast Distance
One of the unsettling things about entanglement is that we can take two qubits, entangle them, move them far apart, and after this they're still entangled.  That is, if we measure one of them and see that it is in state |0>, then the other qubit (which is very far away) immediately 'notices' and collapses its state to |0> as well.  

Anyone who's learned a bit of relativity knows that there's no real meaning to the phrase "Events A and B occurred simultaneously"; we could easily imagine setting up some inertial frames for which our qubits were measured in either order, so that we might quickly confuse ourselves trying to think of which caused the other to collapse, and we might eventually end up in migraine territory if we keep in mind that the qubits couldn't have conspired beforehand on which state they'd eventually collapse to.

Difficult physics aside, the teleportation algorithm itself is actually quite nice.  

Here's the basic layout of the situation:  

 - You and I meet at our local qubit market and we each pick out a qubit.
 - We go to the 'entanglement counter' and ask the friendly qubit cashier to entangle my qubit with your qubit.  Let's keep things simple and say that both our qubits began in state |0> and the cashier simply passed them through a Hadamard-CNOT setup as shown above.
  - We each take one of the qubits with us as we return to our respective homes.
  - Some time later, I've gotten some *other* qubit into an interesting state which I'd like to send to you.
  - I send you a message saying as much, so you know not to measure your qubit from the pair we've entangled.
  - I put my interesting qubit and my entangled qubit through some gates.
  - I make some measurements.
  - I send you a message telling you what the results of my measurements were.
  - Depending on my measured results, you apply some gates to your qubit which was entangled with mine.
  - Your qubit is now in the state my interesting qubit used to be in (!)
  

Here's a quantum circuit which achieves what we want:

 ![Quantum Teleportation](/images/TeleportArbitraryDistance.png)
  

Here's what you need to know to fully analyze this circuit:  
 - The top rail initially contains my interesting qubit - i.e. is in some state a|0> + b|1>.
 - The middle and bottom rails begin in state |0>.
 - After the first Hadamard gate and the first CNOT gate, the middle and bottom rails contain entangled qubits.  I hold onto the middle one and you take the bottom one with you.  If you like, you can imagine cutting this initial piece out of the circuit diagram. 

Once again, it's good practice to work out the final state of this system.  So go ahead and do so, and afterwards you can check with my calculations:

After the first Hadamard and CNOT, the entire system is in state  1/sqrt(2) * (a|000> + a|011> + b|100> + b|111>).

After the next CNOT, the system is in state  1/sqrt(2) * (a|000> + a|011> + b|110> + b|101>).

After the next Hadamard gate, the system is in state  1/2 * (a|000> + a|100> + a|011> + a|111> + b|010> - b|110> + b|001> - b|101>).  Note that two of these states occur with negative amplitude from the Hadamard gate acting on |1> states.

After measurement but before Z and X gates:
 - If 00:  Bottom qubit is in state   a|0> + b|1>.    (To be a bit more clear, this comes from the fact that there are only two states in our superposition for which the first and second bits are 00, namely the a|000> and the b|001> .)  
 - If 01: Bottom qubit is in state   a|1> + b|0>.  
 - If 10: Bottom qubit is in state   a|0> - b|1>.
 - If 11: Bottom qubit is in state   a|1> - b|0>.

Let's analyze these a little.  
 - If I measured 00 from my two qubits, then your qubit is already in state   a|0> + b|1> (!).  So I send you a (classical) message saying as much.
 - If I measure 01, then your qubit is in state a|1> + b|0>, so you need to apply an X gate to it to get it into state a|0> + b|1>.  I send you a message saying as much.
 - If I measure 10, then your qubit is in state a|0> - b|1>, so you need to apply a Z gate to it to get it into the right state.  I send you a message saying as much.
 - If I measure 11, then your qubit is in state a|1> - b|0>, so you need to apply a Z gate followed by an X gate to get it into the right state.  I send you a message saying as much.
 
Note that you have to apply a Z gate precisely in the cases where I've measured my first qubit as 1, and you have to apply an X gate precisely when I've measured my second qubit as 1.  This explains the last part of the diagram, but keep in mind that these last two connections are 'logical', meaning we don't need to physically connect the top rail to the bottom rail.  Instead I just need to tell you my measurement results and you can use your own X and Z gates to put your qubit into the desired state.


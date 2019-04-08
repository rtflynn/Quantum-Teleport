# Quantum Teleportation
For a quick primer on quantum computing and the use of the Q# programming language, see https://blogs.msdn.microsoft.com/uk_faculty_connection/2018/02/06/a-beginners-guide-to-quantum-computing-and-q/ . I'll be assuming some small amount of comfort with the ideas laid out there.

The main idea of quantum teleportation is as follows:  Given two qubits q1 and q2 (not necessarily being held in the same location), transfer the state of q1 to q2.  We are allowed to prepare whatever quantum or classical states we want beforehand, and we are allowed to communicate any number of classical bits in order to transfer our state from q1 to q2.  We require that q1 and q2 do not end up entangled with each other, i.e. simply entangling q1 and q2 via "CNOT(q1, q2); Hadamard(q1);" doesn't count as a solution.  In other words, we'd like to be able to reset q1 after this process without affecting q2.

For ordinary bits, this would be no problem:  Simply read q1, send the information to the facility holding q2, and have someone at that facility set q2 to that value.  This won't work with a quantum system because to read q1 is to measure it, so if q1 were in some superposition of |0> and |1> and we measured q1 as |0>, then setting q2 to |0> would not be the same as setting q2 to the original state of q1.  Equally fundamentally, even if we did know the state of q1, unless q1 were particularly simple it could take an infinite number of classical bits to write this state down.  

It's worth mentioning the no-cloning theorem, which says that it's impossible to create a perfect copy of an unknown quantum state.  This implies that there's no way to solve this problem without somehow changing q1.  It implies a bit more - namely, if we could transfer the state of q1 to q2, then we can't in principle do anything to q1 to get it back to the state it used to be in without doing something to q2 which knocks it out of its new state.  This serves as a nice hint for how quantum teleportation might be done:  (1) Start out with q1 and q2, where q1 is in some unknown state and q2 is (crucially) in some known state.  (2) Mess around with entanglement and superposition a bit.  (3) End with q1 in a known state and q2 in the state q1 used to hold.


# Quick Review of States
Recall that a single qubit can be in the state   a|0> + b|1>  , where a and b are complex numbers whose squared magnitudes sum to 1 ( |a|^2 + |b|^2 = 1 ).  The numbers a and b are called amplitudes, and for a qubit in the state a|0> + b|1> the probability of measuring the qubit in (say) state |0> is |a|^2.

A two-qubit system is in some state a|00> + b|01> + c|10> + d|11>, where again a, b, c, d are complex numbers whose squared magnitudes sum to 1.  Again these coefficients are called amplitudes, and again their squared magnitudes give probabilities of measurements having certain outcomes.  So, for example, if we measure both qubits then we'll find that with probability |c|^2 the first qubit is measured as 1 and the second is measured as 0.

A general n-qubit system can be written and interpreted analagously.  

Once a qubit has been measured, its state 'collapses' to the state which was measured.  For example, suppose we somehow got a qubit to the state  0.6*|0> + 0.8*|1>, meaning that upon measurement we'd expect to see |0> with 36% probability and |1> with 64% probability.  Once we measure the qubit (let's say we read a '0'), its state collapses to the state  1*|0> + 0*|1>.  If we were to measure our qubit again, we'd get the same measurement with 100% probability.  In this way



# Quick Review of Quantum Gates
We only need a few types of quantum gate for this project.  These are popular gates with lots of online references.

## 1-Qubit Gates
X Gate (also called NOT gate):  Sends |0> to |1>   and  |1> to |0>.  
Fleshed out a little more, this means that the X gate sends a qubit in state  a|0> + b|1> to the state b|0> + a|1>.  This linearity is a general feature of quantum gates - i.e. we can explain fully what a quantum gate does to a system just by specifying what it does to a chosen set of basis states.

![Hadamard Circuit Diagram](/images/XGateDiagram.png)

Z Gate:   Sends |0> to |0>  and |1> to -|1>.  
Therefore Z sends a|0> + b|1> to a|0> - b|1>.  Note that this does not impact the probability of observing a given outcome because |b|^2 = |-b|^2.  Rather, the effects of a Z gate are seen after other gates have been applied.

![Hadamard Circuit Diagram](/images/ZGateDiagram.png)

Hadamard Gate:  Sends |0> to 1/sqrt(2) * (|0> + |1>)  and  |1| to 1/sqrt(2) * (|0> - |1>).
The main use of the Hadamard gate (at least in this project) is to take qubits which are in a classical state (for example, in the state |0>)  and to put them into a superposition.  If we begin with a qubit in state |0> and send it through the Hadamard gate, we get a qubit which has equal probability of being measured as 0 or 1.  (Neat!)

![Hadamard Circuit Diagram](/images/HadamardDiagram.png)

## 2-Qubit Gate
There are lots of 2-qubit gates, but we only make use of one particular type in this project.

CNOT Gate:  In principle it's only necessary to specify what this gate does on any basis state, so here goes:  The CNOT gate sends |00> to |00>, |01> to |01>, |10> to |11>, |11> to |10>  (and thus we can write down what the CNOT gate does to an arbitrary pair of qubits in any superposition).  

![Hadamard Circuit Diagram](/images/CNOTGateDiagram.png)

More intuitively, the CNOT gate performs a NOT operation on the second qubit if the first qubit has value 1.  This gets a little messy to think about, because we want to think about qubits as not having particular values until they're measured, and we certainly don't want our gates to be measuring anything!  So what's meant here is that the CNOT gate simply acts by the above mathematical definition - i.e. interchanges the amplitudes for the events |10> and |11>.  

CNOT stands for "Controlled NOT"; we often think of the first qubit as the "control bit" and the second qubit as the "target bit".  The main use of the CNOT gate (in this project) is to entangle two qubits.  

# Quick Review of Entanglement
We can entangle two quantum bits by use of the CNOT gate.  This is a point which is not made clearly enough in the beginner tutorials on the subject - i.e. it's usually stated, or at least suggested, that to create entanglement we need both a Hadamard gate and a CNOT gate arranged as in the image below:

![Hadamard Circuit Diagram](/images/EntanglementDiagram.png)

The truth is, the CNOT gate alone is enough to entangle two states, but for classical states |0> and |1> it's just not interesting to do so.  


// Of course the question still stands:  Can we teleport a quantum system with several entangled qubits in it?
// Let's think about this after we've coded the 1-qubit version.


namespace Quantum.Quantum_Teleport_Single_Qubit
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
    operation QuantumTeleport (msg : Qubit, target : Qubit) : Unit {
        using (middleMan = Qubit())
		{
			// On paper, we have 3 'rails' with a total of 2 Hadamard gates, 2 CNOT gates, 2 measurements, 
			// and at the end either nothing, an X gate, a Z gate, or Z followed by X.
			// We want to first entangle the target qubit with the middleMan qubit.  Then we'll do some entangling
			// of the middleMan with the msg qubit.  Finally, a bit of measurement on the middleMan and msg qubit
			// will tell us what needs to be done to the target qubit so that it is in the same state msg started in.

			H(middleMan);
			CNOT(middleMan, target);
			CNOT(msg, middleMan);
			H(msg);
			let msgMeasurement = M(msg);
			let middlemanMeasurement = M(middleMan);
						
			if (msgMeasurement == One) { Z(target); }
			if (middlemanMeasurement == One) { X(target);}	

			Reset(middleMan);
		}			   		 	  
    }

	// So we have a QuantumTeleport(msg, target) function.  We can use this to send classical data by letting the msg
	// qubit be a classical bit, i.e. a qubit in state |0> or |1> .

	operation TeleportClassicalMessage(message : Bool) : Bool
	{
		mutable measurement = false;

		using (teleportPair = Qubit[2])
		{
			let msg = teleportPair[0];
			let target = teleportPair[1];
			// These start out in the |0> state because we've just recruited them.

			if (message) {X(msg);}		// If our message is 1, flip msg to |1>

			QuantumTeleport(msg, target);	// Now the message has been teleported to target.  msg doesn't hold our message any more.
			
			if (M(target) == One)
			{
				set measurement = true;
			}

			ResetAll(teleportPair);
		}

		return measurement;
	}

	// Now to send more complicated states:  We'll send some states of the form 1/sqrt(2)*( |0> +/- |1> ) .
	// Note that even though these are superpositions, we can still tell which of these two states we're in 
	// (granted we're told we're in one of these states) by applying a Hadamard gate.

	operation TeleportNonclassicalQubit(sign : Bool) : Bool
	{
		mutable measurement = false;

		using (teleportPair = Qubit[2])
		{
			let msg = teleportPair[0];		// msg starts out as |0>
			let target = teleportPair[1];	//

			if (sign) { X(msg); }			
			H(msg);							// Now msg is 1/sqrt(2) * (|0> +/- |1>) , the +/- depending on our sign Bool.

			QuantumTeleport(msg, target);
			// Now target is 1/sqrt(2) * (|0> +/- |1>), again depending on the original sign Bool value.

			H(target);						// Now target is |0> or |1>
			if (M(target) == One) {set measurement = true;}
						
			ResetAll(teleportPair);
		}

		return measurement;
	}





}

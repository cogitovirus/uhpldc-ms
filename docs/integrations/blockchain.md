# Azure Blockchain Service,

Probably go with Corda.

Corda is more focused on business processes and does not have a native concept of tokens like Ethereum. However, you can create and manage states that represent assets.

Steps to Create a Custom Asset on Corda

1. Set Up Azure Blockchain Service:
    • Create a new instance of Azure Blockchain Service and choose Corda as your blockchain protocol.
2. Write a Contract for Your Asset:
    • In Corda, you define states, contracts, and flows. Here’s an example of a simple asset state:

    ```java
    import net.corda.core.contracts.CommandData;
    import net.corda.core.contracts.Contract;
    import net.corda.core.contracts.ContractState;
    import net.corda.core.identity.AbstractParty;
    import net.corda.core.transactions.LedgerTransaction;

    import java.util.Collections;
    import java.util.List;

    public class MyAsset implements ContractState {
        private final AbstractParty owner;
        private final int value;

        public MyAsset(AbstractParty owner, int value) {
            this.owner = owner;
            this.value = value;
        }

        public AbstractParty getOwner() {
            return owner;
        }

        public int getValue() {
            return value;
        }

        @Override
        public List<AbstractParty> getParticipants() {
            return Collections.singletonList(owner);
        }
    }

    public class MyAssetContract implements Contract {
        @Override
        public void verify(LedgerTransaction tx) {
            // Contract verification logic
        }

        public interface Commands extends CommandData {
            class Issue implements Commands {}
        }
    }
    ```

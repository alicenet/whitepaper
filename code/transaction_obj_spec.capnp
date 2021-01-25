using Go = import "/go.capnp";
@0xb99093b7d2518300;
$Go.package("capn");
$Go.import("github.com/MadHive/MadNet/application/capn");

const defaultDSPreImage :DSPreImage = (chainID = 0, index = 0x"00", 
    issuedAt = 0, deposit = 0, rawData = 0x"00", owner = 0x"00");
const defaultDSLinker :DSLinker = (txHash = 0x"00",
    dSPreImage = .defaultDSPreImage);
const defaultVSPreImage :VSPreImage = (chainID = 0, value = 0,
    owner = 0x"00");
const defaultASPreImage :ASPreImage = (chainID = 0, value = 0,
    owner = 0x"00", issuedAt = 0, exp = 0);
const defaultTXInPreImage :TXInPreImage = (chainID = 0,
    consumedTxIdx = 0, consumedTxHash = 0x"00");
const defaultTXInLinker :TXInLinker = (
    tXInPreImage = .defaultTXInPreImage, txHash = 0x"00");

struct DSPreImage {
    chainID @0 :UInt32 = 0;
    # The chainID of the chain this object was created on.

    index @1 :Data = 0x"00";
    # The index of this data reference.

    issuedAt @2 :UInt32 = 0;
    # The Epoch during which this object was created.

    deposit @3 :UInt32 = 0;
    # The deposit given to this datastore.

    rawData @4 :Data = 0x"00";
    # The raw data associated with this data store.

    tXOutIdx @5 :UInt32 = 0;
    # The index at which this element appears in the transaction
    # output list.

    owner @6 :Data = 0x"00";
    # The hash of the public key of the owner of this object.
}

struct DSLinker {
    dSPreImage @0 :DSPreImage = .defaultDSPreImage;
    # The structure containing particular information for this object.

    txHash @1 :Data = 0x"00";
    # The hash of the transaction that created this object.
}

struct DataStore {
    dSLinker @0 :DSLinker = .defaultDSLinker;
    # Linking from object to txHash.

    signature @1 :Data = 0x"00";
    # Signature of the DSLinker
}

########################################################################

struct VSPreImage {
    chainID @0 :UInt32 = 0;
    # The chainID of this object.

    value @1 :UInt32 = 0;
    # The value stored in this object.

    tXOutIdx @2 :UInt32 = 0;
    # The index at which this element appears in the transaction
    # output list.

    owner @3 :Data = 0x"00";
    # The hash of the public key of the owner of this object.
}

struct ValueStore {
    vSPreImage @0 :VSPreImage = .defaultVSPreImage;
    # The structure containing particular information for this object.

    txHash @1 :Data = 0x"00";
    # The hash of the transaction that created this object.
}

########################################################################

struct ASPreImage {
    chainID @0 :UInt32 = 0;
    # The chainID of this object.

    value @1 :UInt32 = 0;
    # The value stored in this object.

    tXOutIdx @2 :UInt32 = 0;
    # The index at which this element appears in the transaction
    # output list.

    owner @3 :Data = 0x"00";
    # <sva><curve><hashlock><initial owner pubk hash><partner pubk hash>
    # The hash of the public key of the original owner of this object.

    issuedAt @4 :UInt32 = 0;
    # The Epoch during which this object was created.

    exp @5 :UInt32 = 0;
    # The Epoch during which this object will fall back to the original 
    # owner if it is not claimed by the partner before this point.
    # For safety this should be at least three epochs after issuedAt.
}

struct AtomicSwap {
    aSPreImage @0 :ASPreImage = .defaultASPreImage;
    # The structure containing particular information for this object.

    txHash @1 :Data = 0x"00";
    # The hash of the transaction that created this object.
}

########################################################################

struct TXInPreImage {
    chainID @0 :UInt32 = 0;
    # Chain id on which this object was created.

    consumedTxIdx @1 :UInt32 = 0;
    # Index at which the consumed object was created in the tx named
    # by consumedTxHash or the max value of uint32 to signal a deposit
    # from Ethereum.

    consumedTxHash @2 :Data = 0x"00";
    # The hash of the transaction that created the object to be
    # consumed or the nonce of the deposit if input is a deposit from
    # Ethereum bc.
}

struct TXInLinker {
    tXInPreImage @0 :TXInPreImage = .defaultTXInPreImage;
    # The structure containing particular information for this object.

    txHash @1 :Data = 0x"00";
    # The hash of the transaction that is consuming this object.
}

struct TXIn {
    tXInLinker @0 :TXInLinker = .defaultTXInLinker;
    # Linking from object to txHash.

    signature @1 :Data = 0x"00";
    # Signature of linker.
}

########################################################################

struct TXOut {
    union {
        dataStore  @0 :DataStore;
        # The output if it is a datastore

        valueStore  @1 :ValueStore;
        # The output if it is a valuestore

        atomicSwap @2 :AtomicSwap;
    }
}

########################################################################

struct Tx {
    vin @0 :List(TXIn) = [];
    # Transaction input vector.

    vout @1 :List(TXOut) = [];
    # Transaction output vector.
}

########################################################################

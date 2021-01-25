func (ce *Engine) doPendingProposalStep(
        txn *badger.Txn, rs *roundStates) error {
    // if local node is the proposer for this round
    // make a proposal
    if rs.localIsProposer() {
        // if not locked or valid form new proposal
        if !rs.LockedValueCurrent() && !rs.ValidValueCurrent() {
            // 00 case
            return ce.castNewProposalValue(txn, rs)
        }
        // if not locked but valid known, propose valid value
        if !rs.LockedValueCurrent() && rs.ValidValueCurrent() {
            // 01 case
            return ce.castProposalFromValue(txn, rs, rs.ValidValue())
        }
        // if locked, propose locked
        // 10
        // 11 case
        return ce.castProposalFromValue(txn, rs, rs.LockedValue())
    }
    // local node is not proposer,
    // do nothing until proposal timeout
    return nil
}

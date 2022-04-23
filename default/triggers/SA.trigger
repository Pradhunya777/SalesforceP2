trigger SA on Opportunity (After insert) {
    SA.Calc();
}
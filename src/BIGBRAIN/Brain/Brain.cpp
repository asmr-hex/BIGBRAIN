/*
 *
 *          |           |
 *          |_  o  _    |_  ._  _  o ._
 *          |_) | (_|   |_) |  |-| | | |
 *                 _|
 *
 */

#include <BIGBRAIN/Brain/Brain.hpp>
#include <iostream>

namespace Bb{

// Brain Constructor
Brain::Brain() {
    std::cout << "Whelp, its a brain!\n";
}

// Neural State Getter
int Brain::NeuralState() {
    return 666;
}



} // namespace Bb

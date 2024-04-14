// Define the NFT struct
struct NFT {
    id: u64,
    owner: address,
    // Add any other relevant fields for your NFT
}

// Define the rental agreement struct
struct RentalAgreement {
    nft_id: u64,
    renter: address,
    start_time: u64,
    end_time: u64,
    // Add any other relevant fields for your rental agreement
}

// Define the marketplace module
module RentalMarketplace {
    // Store the NFTs and rental agreements
    resource T {
        // Store NFTs
        nfts: vector<NFT>;

        // Store rental agreements
        rental_agreements: vector<RentalAgreement>;
    }

    // Initialize the marketplace
    public fun init() {
        // Initialize empty storage for NFTs and rental agreements
        move_to<T>(Global<T>).nfts = [];
        move_to<T>(Global<T>).rental_agreements = [];
    }

    // Rent an NFT
    public fun rent_nft(nft_id: u64, renter: address, start_time: u64, end_time: u64) {
        // Ensure the NFT exists
        let nfts = &mut move_from<T>(Global<T>).nfts;
        let nft_index = nfts.iter().position(|nft| nft.id == nft_id);
        assert(move(nft_index).is_some(), 101);

        // Ensure the NFT is not already rented
        let rental_agreements = &move_from<T>(Global<T>).rental_agreements;
        assert(!rental_agreements.exists(|agreement| agreement.nft_id == nft_id), 102);

        // Create a new rental agreement
        let agreement = RentalAgreement {
            nft_id: nft_id,
            renter: renter,
            start_time: start_time,
            end_time: end_time,
        };

        // Add the rental agreement to storage
        move_to<T>(Global<T>).rental_agreements.push(agreement);
    }

    // Return an NFT
    public fun return_nft(nft_id: u64) {
        // Ensure the NFT is rented
        let rental_agreements = &mut move_from<T>(Global<T>).rental_agreements;
        let agreement_index = rental_agreements.iter().position(|agreement| agreement.nft_id == nft_id);
        assert(move(agreement_index).is_some(), 103);

        // Remove the rental agreement from storage
        move_to<T>(Global<T>).rental_agreements.swap_remove(move(agreement_index).unwrap());
    }

    // Get rental agreement details for an NFT
    public fun get_rental_agreement(nft_id: u64): RentalAgreement {
        // Ensure the NFT is rented
        let rental_agreements = &move_from<T>(Global<T>).rental_agreements;
        let agreement = rental_agreements.find(|agreement| agreement.nft_id == nft_id);
        assert(move(agreement).is_some(), 104);
        move(agreement).unwrap()
    }
}

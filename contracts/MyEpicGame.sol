// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "./libraries/Base64.sol";

// Our contract inherits from ERC721, which is the standard NFT contract!
contract MyEpicGame is ERC721 {
  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;
    string attackImageURI;
    string eatImageURI;
    string loseImageURI;        
    uint hp;
    uint maxHp;
    uint attackDamage;
    uint healAmount;
    uint criticalChance;
  }

  struct ChAtt {
    string name;
    string imageURI;
    string attackImageURI;
    string eatImageURI;
    string loseImageURI;        
    uint hp;
    uint attackDamage;
    uint healAmount;
    uint criticalChance;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CharacterAttributes[] defaultChars;

  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  struct BigBoss {
    string name;
    string imageURI;
    string attackImageURI;
    string eatImageURI;
    string loseImageURI;
    uint hp;
    uint maxHp;
    uint attackDamage;
  }

  BigBoss public bigBoss;

  mapping(address => uint256) public nftHolders;

  event CharacterNFTMinted(address sender, uint256 tokenId, uint256 defaultCharacterIndex);
  event AttackComplete(uint newBossHp, uint newPlayerHp, uint characterIndex, bool isCritical);

  constructor(
    ChAtt[] memory characterAttrs,
    string memory bossName, // These new variables would be passed in via run.js or deploy.js.
    string memory bossImageURI,
    string memory bossAttackImageURI,
    string memory bossEatImageURI,
    string memory bossLoseImageURI,
    uint bossHp,
    uint bossAttackDamage
  )
    ERC721("Companies", "Company")
  {
    bigBoss = BigBoss({
      name: bossName,
      imageURI: bossImageURI,
      attackImageURI: bossAttackImageURI,
      eatImageURI: bossEatImageURI,
      loseImageURI: bossLoseImageURI,
      hp: bossHp,
      maxHp: bossHp,
      attackDamage: bossAttackDamage
    });

    console.log("Done initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);
    for (uint i = 0; i < characterAttrs.length; i += 1) {
      defaultChars.push(CharacterAttributes({
        characterIndex: i,
        name: characterAttrs[i].name,
        imageURI: characterAttrs[i].imageURI,
        attackImageURI: characterAttrs[i].attackImageURI,
        loseImageURI: characterAttrs[i].loseImageURI,
        eatImageURI: characterAttrs[i].eatImageURI,
        hp: characterAttrs[i].hp,
        maxHp: characterAttrs[i].hp,
        attackDamage: characterAttrs[i].attackDamage,
        healAmount: characterAttrs[i].healAmount,
        criticalChance: characterAttrs[i].criticalChance
      }));

      CharacterAttributes memory c = defaultChars[i];
      console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
    }
  }

  function mintCharacterNFT(uint _chIdx) external {
    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();

    // The magical function! Assigns the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: newItemId,
      name: defaultChars[_chIdx].name,
      imageURI: defaultChars[_chIdx].imageURI,
      attackImageURI: defaultChars[_chIdx].attackImageURI,
      loseImageURI: defaultChars[_chIdx].loseImageURI,
      eatImageURI: defaultChars[_chIdx].eatImageURI,
      hp: defaultChars[_chIdx].hp,
      maxHp: defaultChars[_chIdx].hp,
      attackDamage: defaultChars[_chIdx].attackDamage,
      healAmount: defaultChars[_chIdx].healAmount,
      criticalChance: defaultChars[_chIdx].criticalChance
    });
    
    nftHolders[msg.sender] = newItemId;

    emit CharacterNFTMinted(msg.sender, newItemId, _chIdx);
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

    string memory strHp = Strings.toString(charAttributes.hp);
    string memory strMaxHp = Strings.toString(charAttributes.maxHp);
    string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);
    string memory healAmount = Strings.toString(charAttributes.healAmount);
    string memory criticalChance = Strings.toString(charAttributes.criticalChance);


    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
            strAttackDamage,'}, { "trait_type": "Heal Amount", "value": ',healAmount,'}, { "trait_type": "Critical chance", "value": ',criticalChance,'} ]}'
          )
        )
      )
    );

    string memory output = string(
      abi.encodePacked("data:application/json;base64,", json)
    );
    
    return output;
  }

  function attackBoss() public {
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);
    require (
      player.hp > 0,
      "Error: character must have HP to attack boss."
    );

    require (
      bigBoss.hp > 0,
      "Error: boss must have HP to attack boss."
    );

    uint multiplier = 1;
    bool isCritical = rand() < player.criticalChance;

    if (isCritical) {
      multiplier = 2;
    }

    if (bigBoss.hp < player.attackDamage * multiplier) {
      bigBoss.hp = 0;
    } else {
      bigBoss.hp = bigBoss.hp - player.attackDamage * multiplier;
    }

    console.log("Player attacked boss. New boss hp %s", bigBoss.hp);

    // Allow boss to attack player.
    if (player.hp < bigBoss.attackDamage) {
      player.hp = 0;
    } else {
      player.hp = player.hp - bigBoss.attackDamage;
    }
    
    emit AttackComplete(bigBoss.hp, player.hp, player.characterIndex, isCritical);
  }

  function heal() public {
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    require(player.hp < player.maxHp, 'Your hp is full');
    if (player.hp + player.healAmount > player.maxHp) {
      player.hp = player.maxHp;
    } else {
      player.hp += player.healAmount;
    }

    emit AttackComplete(bigBoss.hp, player.hp, player.characterIndex, false);
  }

  function getCharacterNFT() public view returns (CharacterAttributes memory) {
    uint256 userNftTokenId = nftHolders[msg.sender];
    if (userNftTokenId > 0) {
      return nftHolderAttributes[userNftTokenId];
    }
    else {
      CharacterAttributes memory emptyStruct;
      return emptyStruct;
    }    
  }

  function getAllDefaultChars() public view returns (CharacterAttributes[] memory) {
    return defaultChars;
  }

  function getBigBoss() public view returns (BigBoss memory) {
    return bigBoss;
  }

  function getAllCharacters() public view returns (CharacterAttributes[] memory) {
    uint256 current = _tokenIds.current();
    CharacterAttributes[] memory characters = new CharacterAttributes[](current);

    for (uint256 i = 1; i <= current; i++) {
      characters[i - 1] = nftHolderAttributes[i];
    }

    return characters;
  }

  function rand() internal view returns(uint) {
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
  }
}
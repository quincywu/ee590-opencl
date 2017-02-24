class OddEvenMergeSorter {

public:

  Boolean(bool b);
  Boolean ( const Boolean &b );
  ~Boolean() {};

  Boolean * clone() { return new Boolean(*this); }
  void set(bool b);
  std::string stringify();

private:

  bool int[] a;

};

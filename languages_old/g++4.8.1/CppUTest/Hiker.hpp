#ifndef HIKER_INCLUDED
#define HIKER_INCLUDED

class Hiker
{
public:
  explicit Hiker();
  ~Hiker();

  int answer() const;

  Hiker(const Hiker &) = delete;
  Hiker & operator=(const Hiker &) = delete;
};

#endif

import bcrypt from 'bcrypt';

(async () => {
    const password = '1';
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('Hashed Password:', hashedPassword);
  })();
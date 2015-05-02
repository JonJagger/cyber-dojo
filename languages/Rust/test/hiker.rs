
pub fn answer() -> i32 {
    6 * 9
}

#[cfg(test)]
mod tests {
    use super::answer;

    #[test]
    fn life_the_universe_and_everything() {
        assert_eq!(42, answer());
    }
}